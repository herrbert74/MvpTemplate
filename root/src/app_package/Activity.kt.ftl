package ${fullPackageName}

import android.arch.lifecycle.ViewModelProviders
import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.jakewharton.rxbinding2.view.clicks
import com.jakewharton.rxbinding2.widget.RxTextView
import com.uber.autodispose.AutoDispose
import com.uber.autodispose.ScopeProvider
import com.ubercab.autodispose.rxlifecycle.RxLifecycleInterop
import com.trello.rxlifecycle2.components.support.RxAppCompatActivity
import io.reactivex.CompletableSource
import kotlinx.android.synthetic.main.activity_${className?lower_case}.*
import ${fullPackageName}.list.${className}Adapter
import ${fullPackageName}.list.AbstractCharges2Visitable
import ${applicationPackage}.R
import ${basePackageName}.mvp.ErrorType
import ${basePackageName}.mvp.list.BaseViewHolder
import ${basePackageName}.view.MultiStateView.*
import ${applicationPackage}.Injector

private const val CUSTOM_PARAMETER = "${packageName}.CUSTOM_PARAMETER"

class ${className}Activity : RxAppCompatActivity(), ScopeProvider {

	override fun requestScope(): CompletableSource = RxLifecycleInterop.from(this).requestScope()

	private val viewModel by lazy { ViewModelProviders.of(this).get(${className}ViewModel::class.java) }

	private var ${className?lower_case}Adapter: ${className}Adapter? = null
	
	private lateinit var ${className?uncap_first}Presenter: ${className}PresenterContract

	//region life cycle
	
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_${className?lower_case})
		setSupportActionBar(pab${className}.getToolbar())
		supportActionBar?.setDisplayHomeAsUpEnabled(true)
		pab${className}.setNavigationOnClickListener { onBackPressed() }
		supportActionBar?.title = "${className}"
		initPresenter(intent.extras.getString(CUSTOM_PARAMETER)!!)
		observeActions()
		observeState()
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
				//TODO
				//Do something here
			}
		}
	}

	//endregion

	//region events

	private fun observeActions() {
		${className?uncap_first}Adapter?.getViewClickedObservable()
				?.take(1)
				?.`as`(AutoDispose.autoDisposable(this))
				?.subscribe { view: BaseViewHolder<AbstractCharges2Visitable> -> ${className?uncap_first}Presenter.on${listClassNamePlural}ItemClicked(view) }
	}

	//endregion
}

fun Context.create${className}Intent(${parameterName}: String): Intent {
	return Intent(this, ${className}Activity::class.java)
		.putExtra(CUSTOM_PARAMETER, ${parameterName})
}
