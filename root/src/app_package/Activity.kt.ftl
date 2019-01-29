package ${fullPackageName}

import android.arch.lifecycle.ViewModelProviders
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import com.uber.autodispose.AutoDispose
import com.uber.autodispose.ScopeProvider
import com.ubercab.autodispose.rxlifecycle.RxLifecycleInterop
import com.trello.rxlifecycle2.components.support.RxAppCompatActivity
import io.reactivex.CompletableSource
import kotlinx.android.synthetic.main.activity_${className?lower_case}.*
import ${fullPackageName}details.create${className}DetailsIntent
import ${applicationPackage}.R
import ${basePackageName}.mvp.ErrorType
import ${basePackageName}.mvp.list.BaseViewHolder
import ${basePackageName}.view.MultiStateView.*
import ${applicationPackage}.Injector
import ${basePackageName}.view.DividerItemDecoration
import ${basePackageName}.view.EndlessRecyclerViewScrollListener
import ${applicationPackage}.ext.startActivityWithRightSlide
import ${fullPackageName}.list.*

private const val CUSTOM_PARAMETER = "${packageName}.CUSTOM_PARAMETER"

class ${className}Activity : RxAppCompatActivity(), ScopeProvider {

	override fun requestScope(): CompletableSource = RxLifecycleInterop.from(this).requestScope()

	private val viewModel by lazy { ViewModelProviders.of(this).get(${className}ViewModel::class.java) }

	private var ${className?lower_case}Adapter: ${className}Adapter? = null

	private lateinit var ${className?uncap_first}Presenter: ${className}PresenterContract

	private val eventDisposables: CompositeDisposable = CompositeDisposable()

	//region life cycle
	
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_${className?lower_case})
		setSupportActionBar(pab${className}.getToolbar())
		supportActionBar?.setDisplayHomeAsUpEnabled(true)
		pab${className}.setNavigationOnClickListener { onBackPressed() }
		supportActionBar?.title = "${className}"
		initPresenter(intent.extras.getString(CUSTOM_PARAMETER)!!)
		createRecyclerView()
		observeState()
	}

	override fun onResume() {
		super.onResume()
		observeActions()
	}

	private fun initPresenter(customParameter: String) {
		val maybePresenter = lastCustomNonConfigurationInstance as ${className}PresenterContract?

		if (maybePresenter != null) {
			${className?uncap_first}Presenter = maybePresenter
		}

		if (!::${className?uncap_first}Presenter.isInitialized) {
			viewModel.state.value.${parameterName} = customParameter
			${className?uncap_first}Presenter = Injector.get().${className?uncap_first}Presenter()
			${className?uncap_first}Presenter.setViewModel(viewModel, requestScope())
		}
	}

	private fun createRecyclerView() {
		val linearLayoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
		rv${className}?.layoutManager = linearLayoutManager
		rv${className}?.addItemDecoration(DividerItemDecoration(this))
		rv${className}?.addOnScrollListener(object : EndlessRecyclerViewScrollListener(linearLayoutManager) {
			override fun onLoadMore(page: Int, totalItemsCount: Int) {
				${className?uncap_first}Presenter.loadMore${className}(page)
			}
		})
	}

	//endregion

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
			state.${listClassName?lower_case}Items == null -> msv${className}.viewState = VIEW_STATE_EMPTY
			else -> {
				msv${className}.viewState = VIEW_STATE_CONTENT
				if (rv${className}?.adapter == null) {
					${className?uncap_first}Adapter = Charges2Adapter(viewModel.state.value.${listClassName?uncap_first}Items, ${className}TypeFactory())
					rv${className}?.adapter = ${className?uncap_first}Adapter
					observeActions()
				} else {
					${className?uncap_first}Adapter?.updateItems(viewModel.state.value.${listClassName?uncap_first}Items)
					observeActions()
				}
			}
		}
	}

	//endregion

	//region events

	private fun observeActions() {
		eventDisposables.clear()
		${className?uncap_first}Adapter?.getViewClickedObservable()
				?.take(1)
				?.`as`(AutoDispose.autoDisposable(this))
				?.subscribe { view: BaseViewHolder<AbstractCharges2Visitable> -> 
					startActivityWithRightSlide(
							this.create${className}DetailsIntent(
									(viewModel.state.value.${listClassName?uncap_first}Items[(view as ${className}ViewHolder).adapterPosition] as Charges2Visitable).${className?uncap_first}Item))
				}
				?.let { eventDisposables.add(it) }
	}

	//endregion
}

fun Context.create${className}Intent(${parameterName}: String): Intent {
	return Intent(this, ${className}Activity::class.java)
		.putExtra(CUSTOM_PARAMETER, ${parameterName})
}
