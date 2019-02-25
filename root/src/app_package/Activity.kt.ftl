package ${fullPackageName}

import android.content.Context
import android.content.Intent
import android.os.Bundle

import kotlinx.android.synthetic.main.activity_${camelCaseToUnderscore(className)}.*
import ${applicationPackage}.R
import ${basePackageName}.mvp.ErrorType
<#if areListItemsClickable>
import ${basePackageName}.mvp.list.BaseViewHolder
<#if isShowingDetails>
import ${fullPackageName}details.create${className}DetailsIntent
import ${applicationPackage}.ext.startActivityWithRightSlide
</#if></#if>
<#if hasSavedData>
import com.uber.autodispose.AutoDispose
import com.uber.autodispose.ScopeProvider
import com.ubercab.autodispose.rxlifecycle.RxLifecycleInterop
import com.trello.rxlifecycle2.components.support.RxAppCompatActivity
import io.reactivex.CompletableSource
import androidx.lifecycle.ViewModelProviders
import ${basePackageName}.view.MultiStateView.*
import ${applicationPackage}.Injector
<#else>
import android.support.v7.app.AppCompatActivity
</#if>
<#if isList>
import androidx.recyclerview.widget.LinearLayoutManager
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

class ${className}Activity : <#if hasSavedData>RxAppCompatActivity(), ScopeProvider<#else>AppCompatActivity()</#if> {

	<#if isList>

	private var ${className?uncap_first}Adapter: ${className}Adapter? = null
	</#if>
	<#if hasSavedData>

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
		<#if hasSavedData>
		when {
			viewModel.state.value.<#if isList>${listClassName?uncap_first}Items<#elseif isCall>${className?uncap_first}<#else>${parameterName}</#if> != null -> {
				initPresenter(viewModel)
			}
			savedInstanceState != null -> {
				savedInstanceState.getParcelable<${className}State>("STATE")?.let {
					with(viewModel.state.value) {
						<#if isList>${listClassName?uncap_first}Items<#elseif isCall>${className?uncap_first}</#if><#if isList || isCall> = it.</#if><#if isList>${listClassName?uncap_first}Items<#elseif isCall>${className?uncap_first}</#if>
						<#if isParameter>
						${parameterName} = it.${parameterName}
						</#if>
					}
				}
				initPresenter(viewModel)
			}
			else -> {
				<#if isParameter>viewModel.state.value.${parameterName} = intent.getStringExtra(${camelCaseToUnderscore(parameterName)?upper_case})</#if>
				initPresenter(viewModel)
			}
		}
	
		<#elseif isCall>
		initPresenter(<#if isParameter>intent?.extras?.getString(${camelCaseToUnderscore(parameterName)?upper_case})!!</#if>)
		</#if>
		<#if isList>
		createRecyclerView()
		</#if>
		observeState()
	}

	override fun onResume() {
		super.onResume()
		observeActions()
	}
	<#if hasSavedData>

	override fun onSaveInstanceState(outState: Bundle) {
		outState.putParcelable("STATE", viewModel.state.value)
		super.onSaveInstanceState(outState)
	}

	private fun initPresenter(viewModel: ${className}ViewModel) {
		if (!::${className?uncap_first}Presenter.isInitialized) {
			${className?uncap_first}Presenter = Injector.get().${className?uncap_first}Presenter()
			${className?uncap_first}Presenter.setViewModel(viewModel, requestScope())
		}
	}
	</#if>
	<#if isList>

	private fun createRecyclerView() {
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
	}
	</#if>
	
	<#if hasMenu>
	override fun onCreateOptionsMenu(menu: Menu): Boolean {
		menuInflater.inflate(R.menu.filing_history_details_menu, menu)
		return true
	}

	override fun onOptionsItemSelected(item: MenuItem): Boolean {
		return when (item.itemId) {
			R.id.action_TODO -> {
				${className?uncap_first}Presenter.TODO
				true
			}
			else -> super.onOptionsItemSelected(item)
		}
	}
	
	</#if>
	
	//endregion
	<#if hasSavedData>

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
				<#if isList>
				state.${listClassName?uncap_first}Items?.let {
					msv${className}.viewState = VIEW_STATE_CONTENT
					if (rv${className}?.adapter == null) {
						${className?uncap_first}Adapter = ${className}Adapter(it, ${className}TypeFactory())
						rv${className}?.adapter = ${className?uncap_first}Adapter
					} else {
						${className?uncap_first}Adapter?.updateItems(it)
					}
					observeActions()
				}
				<#else>
				state.${className?uncap_first}?.let {
					msv${className}.viewState = VIEW_STATE_CONTENT
					show${className}(it)
				}
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
		<#if areListItemsClickable>
		${className?uncap_first}Adapter?.getViewClickedObservable()
				?.take(1)
				?.`as`(AutoDispose.autoDisposable(this))
				?.subscribe { view: BaseViewHolder<Abstract${className}Visitable> -> 
					<#if isShowingDetails>
					viewModel.state.value.${listClassName?uncap_first}Items?.let { ${listClassName?uncap_first}Items ->
						startActivityWithRightSlide(
								this.create${className}DetailsIntent(
										(${listClassName?uncap_first}Items[(view as ${className}ViewHolder).adapterPosition] as ${className}Visitable).${className?uncap_first}Item))
					}
					</#if>
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
