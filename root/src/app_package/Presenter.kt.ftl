package ${fullPackageName}

import android.annotation.SuppressLint
import ${basePackageName}.mvp.BasePresenter
import ${basePackageName}.mvp.Presenter
import ${basePackageName}.rxjava.ObserverWrapper
import ${applicationPackage}.BuildConfig
import com.uber.autodispose.AutoDispose
import ${applicationPackage}.data.${repositoryName}
<#if isList>
import ${fullPackageName}.list.Abstract${className}Visitable
import ${fullPackageName}.list.${className}Visitable
</#if>
import io.reactivex.CompletableSource
import javax.inject.Inject

interface ${className}PresenterContract : Presenter<${className}State, ${className}ViewModel> {
	<#if isCall>
		<#if isList>
	fun fetch${listClassNamePlural}(<#if isParameter>${parameterName} : ${parameterType}</#if>)
			<#if isPaging>
	fun loadMore${listClassNamePlural}(page: Int)
			</#if>
		<#else>
	fun fetch${className}(${parameterName}: String)
		</#if>
	</#if>
}

@SuppressLint("CheckResult")
class ${className}Presenter
@Inject
constructor(var ${repositoryName?uncap_first}: ${repositoryName}) : BasePresenter<${className}State, ${className}ViewModel>(), ${className}PresenterContract {

	override fun setViewModel(viewModel: ${className}ViewModel?, lifeCycleCompletable: CompletableSource?) {
		this.viewModel = viewModel
		this.lifeCycleCompletable = lifeCycleCompletable
		<#if isCall>
		viewModel?.state?.value?.<#if isList>${listClassName?uncap_first}Items<#else>${className?uncap_first}</#if>?.let {
			sendToViewModel {
				it.apply {
					this.isLoading = false
					this.contentChange = ContentChange.<#if isList>${camelCaseToUnderscore(listClassNamePlural)?upper_case}<#else>${camelCaseToUnderscore(className)?upper_case}</#if>_RECEIVED
				}
			}
		} ?: run {
			sendToViewModel {
				it.apply {
					this.isLoading = true
				}
			}
			<#if isList>
				<#if isParameter>
			viewModel?.state?.value?.${parameterName}?.also {
				fetch${listClassNamePlural}(it)
			}
				<#else>
			fetch${listClassNamePlural}()
				</#if>
			<#else>
				<#if isParameter>
			viewModel?.state?.value?.${parameterName}?.also {
				fetch${className}(it)
			}
				<#else>
			fetch${className}()
				</#if>
			</#if>
		}
		<#else>
		sendToViewModel {
			it.apply {
				this.contentChange = ContentChange.${camelCaseToUnderscore(listClassNamePlural)?upper_case}_RECEIVED
				this.${listClassName?uncap_first}Items = convertToVisitables(reply)
			}
		}
		</#if>
	}
	
	<#if isCall>
		<#if isList>
	override fun fetch${listClassNamePlural}(<#if isParameter>${parameterName} : ${parameterType}</#if>) {
		${repositoryName?uncap_first}.fetch${listClassNamePlural}(<#if isParameter>${parameterName}</#if><#if isPaging>, "0"</#if>)
				.`as`(AutoDispose.autoDisposable(lifeCycleCompletable))
				.subscribeWith(object : ObserverWrapper<${listClassNamePlural}>(this) {
					override fun onSuccess(reply: ${listClassNamePlural}) {
						sendToViewModel {
							it.apply {
								this.isLoading = false
								this.contentChange = ContentChange.${camelCaseToUnderscore(listClassNamePlural)?upper_case}_RECEIVED
								this.${listClassName?uncap_first}Items = convertToVisitables(reply)
								<#if isPaging>this.totalCount = reply.totalCount?.toInt()</#if>
							}
						}
					}
				})
	}
	
		<#else>
	override fun fetch${className}(<#if isParameter>${parameterName}: String</#if>) {
		${repositoryName?uncap_first}.fetch${className}(<#if isParameter>${parameterName}</#if>)
				.subscribeWith(object : ObserverWrapper<${className}>(this) {
					override fun onSuccess(reply: ${className}) {
						sendToViewModel {
							it.apply {
								this.isLoading = false
								this.contentChange = ContentChange.${camelCaseToUnderscore(className)?upper_case}_RECEIVED
								this.${className?uncap_first} = reply
							}
						}
					}
				})
	}
		</#if>
	
		<#if isPaging>
	override fun loadMore${listClassNamePlural}(page: Int) {
		if (viewModel?.state?.value?.${listClassName?uncap_first}Items == null || viewModel?.state?.value?.${listClassName?uncap_first}Items!!.size < viewModel?.state?.value?.totalCount!!) {
			${repositoryName?uncap_first}.fetch${listClassNamePlural}(viewModel?.state?.value?.${parameterName}
					?: "", (page * Integer.valueOf(BuildConfig.COMPANIES_HOUSE_SEARCH_ITEMS_PER_PAGE)).toString())
					.subscribeWith(object : ObserverWrapper<${listClassNamePlural}>(this) {
						override fun onSuccess(reply: ${listClassNamePlural}) {
							val newList = viewModel?.state?.value?.${listClassName?uncap_first}Items?.toMutableList()
							newList?.addAll(convertToVisitables(reply))
							sendToViewModel {
								it.apply {
									this.isLoading = false
									this.contentChange = ContentChange.${listClassNamePlural?upper_case}_RECEIVED
									newList?.toList()?.let { list -> this.${listClassName?uncap_first}Items = list }
								}
							}
						}
					})
		}
	}
		</#if>
	</#if>
	
	private fun convertToVisitables(reply: ${listClassNamePlural}): List<Abstract${className}Visitable> {
		return ArrayList(reply.items.map { item -> ${className}Visitable(item) })
	}
	
	//TODO Copy this to ApplicationComponent interface
	fun ${className?uncap_first}Presenter(): ${className}Presenter

}