package ${fullPackageName}

import android.content.Context
import android.content.Intent
import android.os.Bundle

import kotlinx.android.synthetic.main.activity_${camelCaseToUnderscore(className)}.*
import ${applicationPackage}.R
import ${basePackageName}.mvp.ErrorType
<#if isShowingDetails>
import ${fullPackageName}details.create${className}DetailsIntent
import ${basePackageName}.mvp.list.BaseViewHolder
import ${applicationPackage}.ext.startActivityWithRightSlide
</#if>
<#if isCall>
import com.uber.autodispose.AutoDispose
import com.uber.autodispose.ScopeProvider
import com.ubercab.autodispose.rxlifecycle.RxLifecycleInterop
import com.trello.rxlifecycle2.components.support.RxAppCompatActivity
import io.reactivex.CompletableSource
import android.arch.lifecycle.ViewModelProviders
import ${basePackageName}.view.MultiStateView.*
import ${applicationPackage}.Injector
<#else>
import android.support.v7.app.AppCompatActivity
</#if>
<#if isList>
import android.support.v7.widget.LinearLayoutManager
import ${fullPackageName}.list.*
import ${basePackageName}.view.DividerItemDecoration
</#if>
<#if isPaging>
import ${basePackageName}.view.EndlessRecyclerViewScrollListener
</#if>

import io.reactivex.disposables.CompositeDisposable

<#if isParameter>
private const val ${camelCaseToUnderscore(parameterName)?upper_case} = "${packageName}.${camelCaseToUnderscore(parameterName)}"
</#if>

class ${className}Activity : <#if isCall>RxAppCompatActivity(), ScopeProvider<#else>AppCompatActivity()</#if> {

	<#if isList>

	private var ${className?uncap_first}Adapter: ${className}Adapter? = null
	</#if>
	<#if isCall>

	override fun requestScope(): CompletableSource = RxLifecycleInterop.from(this).requestScope()
	
	private val viewModel by lazy { ViewModelProviders.of(this).get(${className}ViewModel::class.java) }

	private lateinit var ${className?uncap_first}Presenter: ${className}PresenterContract
	</#if>

	private val eventDisposables: CompositeDisposable = CompositeDisposable()

	//region life cycle
	
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_${camelCaseToUnderscore(className)})
		setSupportActionBar(pab${className}.getToolbar())
		supportActionBar?.setDisplayHomeAsUpEnabled(true)
		pab${className}.setNavigationOnClickListener { onBackPressed() }
		supportActionBar?.setTitle(R.string.${camelCaseToUnderscore(className)}_title)
		<#if isCall>
		initPresenter(<#if isParameter>intent?.extras?.getString(${camelCaseToUnderscore(parameterName)?upper_case})!!</#if>)
		</#if>
		<#if isList>
		createRecyclerView(<#if !isCall && isParameter>intent?.extras?.getString(${camelCaseToUnderscore(parameterName)?upper_case})!!</#if>)
		</#if>
		<#if isCall>
		observeState()
		</#if>
	}

	override fun onResume() {
		super.onResume()
		observeActions()
	}
	<#if isCall>

	private fun initPresenter(<#if isParameter>${parameterName}: ${parameterType}</#if>) {
		val maybePresenter = lastCustomNonConfigurationInstance as ${className}PresenterContract?

		if (maybePresenter != null) {
			${className?uncap_first}Presenter = maybePresenter
		}

		if (!::${className?uncap_first}Presenter.isInitialized) {
			<#if isParameter>
			viewModel.state.value.${parameterName} = ${parameterName}
			</#if>
			${className?uncap_first}Presenter = Injector.get().${className?uncap_first}Presenter()
			${className?uncap_first}Presenter.setViewModel(viewModel, requestScope())
		}
	}
	</#if>

	<#if isList>
	private fun createRecyclerView(<#if !isCall && isParameter>${parameterName}: ${parameterType}</#if>) {
		val linearLayoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
		rv${className}?.layoutManager = linearLayoutManager
		<#if isPaging>
		val titlePositions = java.util.ArrayList<Int>()
		titlePositions.add(0)
		rv{className}.addItemDecoration(DividerItemDecorationWithSubHeading(this, titlePositions))
		<#else>
		rv${className}.addItemDecoration(DividerItemDecoration(this))
		</#if>
		<#if isPaging>
		rv${className}.addOnScrollListener(object : EndlessRecyclerViewScrollListener(linearLayoutManager) {
			override fun onLoadMore(page: Int, totalItemsCount: Int) {
				${className?uncap_first}Presenter.loadMore${className}(page)
			}
		})
		</#if>
		<#if !isCall>
		${className?uncap_first}Adapter = ${className}Adapter(<#if isParameter>${parameterName}</#if>, ${className}TypeFactory())
					rv${className}?.adapter = ${className?uncap_first}Adapter
		</#if>
	}
	</#if>
	
	//endregion
	<#if isCall>

	//region render

	private fun observeState() {
		viewModel.state
				.`as`(AutoDispose.autoDisposable(this))
				.subscribe { render(it) }
	}

	private fun render(state: ${className}State) {
		when {
			state.isLoading -> msv${className}.viewState = VIEW_STATE_LOADING
			state.errorType != ErrorType.NONE -> msv${className}.viewState = VIEW_STATE_ERROR
			<#if isList>
			state.${listClassName?lower_case}Items == null -> msv${className}.viewState = VIEW_STATE_EMPTY
			</#if>
			else -> {
				msv${className}.viewState = VIEW_STATE_CONTENT
				<#if isList>
				if (rv${className}?.adapter == null) {
					${className?uncap_first}Adapter = ${className}Adapter(viewModel.state.value.${listClassName?uncap_first}Items, ${className}TypeFactory())
					rv${className}?.adapter = ${className?uncap_first}Adapter
					observeActions()
				} else {
					${className?uncap_first}Adapter?.updateItems(viewModel.state.value.${listClassName?uncap_first}Items)
					observeActions()
				}
				<#else>
				
				</#if>
			}
		}
	}
	<#if !isList>

	private fun show${className}(${className?uncap_first}: ${className}) {
	}
	</#if>
	
	//endregion
	</#if>

	//region events

	private fun observeActions() {
		eventDisposables.clear()
		<#if isShowingDetails>
		${className?uncap_first}Adapter?.getViewClickedObservable()
				?.take(1)
				?.`as`(AutoDispose.autoDisposable(this))
				?.subscribe { view: BaseViewHolder<AbstractCharges2Visitable> -> 
					startActivityWithRightSlide(
							this.create${className}DetailsIntent(
									(viewModel.state.value.${listClassName?uncap_first}Items[(view as ${className}ViewHolder).adapterPosition] as Charges2Visitable).${className?uncap_first}Item))
				}
				?.let { eventDisposables.add(it) }
		</#if>
	}

	//endregion
}

fun Context.create${className}Intent(<#if isParameter>${parameterName}: ${parameterType}</#if>): Intent {
	return Intent(this, ${className}Activity::class.java)
		<#if isParameter>
		.putExtra(${camelCaseToUnderscore(parameterName)?upper_case}, ${parameterName})
		</#if>
}
