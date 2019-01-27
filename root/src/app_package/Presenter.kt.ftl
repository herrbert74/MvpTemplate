package ${fullPackageName}

import android.annotation.SuppressLint
import ${basePackageName}.mvp.BasePresenter
import ${basePackageName}.mvp.Presenter
import ${basePackageName}.rxjava.ObserverWrapper
import com.uber.autodispose.AutoDispose
import ${applicationPackage}.data.${repositoryName}
import ${fullPackageName}.list.${className}Visitable
import io.reactivex.CompletableSource
import javax.inject.Inject

interface ${className}PresenterContract : Presenter<${className}State, ${className}ViewModel> {
	fun fetch${listClassNamePlural}(${parameterName} : ${parameterType})
	fun on${listClassNamePlural}ItemClicked(view: BaseViewHolder<Abstract${className}Visitable>)
	//fun fetch${listClassName}(${parameterName}: String)
}

@SuppressLint("CheckResult")
class ${className}Presenter
@Inject
constructor(var ${repositoryName?uncap_first}: ${repositoryName}) : BasePresenter<${className}State, ${className}ViewModel>(), ${className}PresenterContract {

	override fun setViewModel(viewModel: ${className}ViewModel?, lifeCycleCompletable: CompletableSource?) {
		sendToViewModel {
			it.apply {
				this.isLoading = true
			}
		}
		viewModel?.state?.value?.${parameterName}?.also {
			fetch${listClassNamePlural}(it)
		}
	}
	
	override fun fetch${listClassNamePlural}(${parameterName} : ${parameterType}) {
		${repositoryName?uncap_first}.fetch${listClassNamePlural}(${parameterName}, "0")
				.`as`(AutoDispose.autoDisposable(lifeCycleCompletable))
				.subscribeWith(object : ObserverWrapper<${listClassNamePlural}>(this) {
					override fun onSuccess(reply: ${listClassNamePlural}) {
						sendToViewModel {
							it.apply {
								this.isLoading = false
								this.contentChange = ContentChange.${listClassNamePlural?upper_case}_RECEIVED
								this.${listClassName?uncap_first}Items = convertToVisitables(reply)
							}
						}
					}
				})
	}
	
	/*override fun fetch${listClassName}(${parameterName}: String) {
		${repositoryName}.fetch${className}(parameter)
				.subscribeWith(object : ObserverWrapper<${listClassName}>(this) {
					override fun onSuccess(reply: ${listClassName}) {
						sendToViewModel {
							it.apply {
								this.isLoading = false
								this.contentChange = ContentChange.MESSAGE_DETAILS
								this.${listClassName}Items = convertHistoryToChatItems(reply)
							}
						}
					}
				})
	}*/
	
	private fun convertToVisitables(reply: ${listClassNamePlural}): List<${className}Visitable>? {
		//TODO
		return null
	}
	
	override fun on${listClassNamePlural}ItemClicked(view: BaseViewHolder<Abstract${className}Visitable>) {
		
	}
	
	//TODO Copy this to ApplicationComponent interface
	fun ${className?lower_case}Presenter(): ${className}Presenter

}