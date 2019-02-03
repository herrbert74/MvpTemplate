package ${fullPackageName}

import android.annotation.SuppressLint
import ${basePackageName}.mvp.BasePresenter
import ${basePackageName}.mvp.Presenter
import ${basePackageName}.rxjava.ObserverWrapper
import ${applicationPackage}.BuildConfig
import com.uber.autodispose.AutoDispose
import ${applicationPackage}.data.${repositoryName}
import ${fullPackageName}.list.Abstract${className}Visitable
import ${fullPackageName}.list.${className}Visitable
import io.reactivex.CompletableSource
import javax.inject.Inject

interface ${className}PresenterContract : Presenter<${className}State, ${className}ViewModel> {
	<#if isCall>
		<#if isList>
	fun fetch${listClassNamePlural}(${parameterName} : ${parameterType})
			<#if isPaging>
	fun loadMore${className}(page: Int)
			</#if>
		<#else>
	//fun fetch${listClassName}(${parameterName}: String)
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
			fetch${listClassName}(it)
		}
				<#else>
		fetch${listClassName}()
				</#if>
			</#if>
		</#if>
	}
	
	<#if isList>
	override fun fetch${listClassNamePlural}(<#if isParameter>${parameterName} : ${parameterType}</#if>) {
		${repositoryName?uncap_first}.fetch${listClassNamePlural}(<#if isParameter>${parameterName}</#if><#if isPaging>, "0"</#if>)
				.`as`(AutoDispose.autoDisposable(lifeCycleCompletable))
				.subscribeWith(object : ObserverWrapper<${listClassNamePlural}>(this) {
					override fun onSuccess(reply: ${listClassNamePlural}) {
						sendToViewModel {
							it.apply {
								this.isLoading = false
								this.contentChange = ContentChange.${listClassNamePlural?upper_case}_RECEIVED
								this.${listClassName?uncap_first}Items = convertToVisitables(reply)
								this.totalCount = reply.totalCount?.toInt()
							}
						}
					}
				})
	}
	
	private fun convertToVisitables(reply: ${listClassNamePlural}): List<Abstract${className}Visitable> {
		return ArrayList(reply.items.map { item -> ${className}Visitable(item) })
	}
	<#else>
	override fun fetch${listClassName}(<#if isParameter>${parameterName}: String</#if>) {
		${repositoryName}.fetch${className}(<#if isParameter>${parameterName}</#if>)
				.subscribeWith(object : ObserverWrapper<${listClassName}>(this) {
					override fun onSuccess(reply: ${listClassName}) {
						sendToViewModel {
							it.apply {
								this.isLoading = false
								this.contentChange = ContentChange.${className}_RECEIVED
								this.${listClassName}Items = convertToVisitables(reply)
							}
						}
					}
				})
	}
	</#if>
	
	<#if isPaging>
	override fun loadMoreCharges2(page: Int) {
		if (viewModel?.state?.value?.chargeItems == null || viewModel?.state?.value?.chargeItems!!.size < viewModel?.state?.value?.totalCount!!) {
			${repositoryName?uncap_first}.fetch${listClassNamePlural}(viewModel?.state?.value?.${parameterName}
					?: "", (page * Integer.valueOf(BuildConfig.COMPANIES_HOUSE_SEARCH_ITEMS_PER_PAGE)).toString())
					.subscribeWith(object : ObserverWrapper<${listClassNamePlural}>(this) {
						override fun onSuccess(reply: ${listClassNamePlural}) {
							val newList = viewModel?.state?.value?.chargeItems?.toMutableList()
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
	
	//TODO Copy this to ApplicationComponent interface
	fun ${className?lower_case}Presenter(): ${className}Presenter

}