package ${fullPackageName}.list

import androidx.recyclerview.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
<#if areListItemsClickable>
import com.jakewharton.rxbinding2.view.RxView
import io.reactivex.Observable
import io.reactivex.subjects.PublishSubject
</#if>
import ${basePackageName}.mvp.list.BaseViewHolder

class ${className}Adapter(private var ${className?uncap_first}Visitables: List<Abstract${className}Visitable>
					  , private val ${className?uncap_first}TypeFactory: ${className}TypeFactory)
	: RecyclerView.Adapter<BaseViewHolder<Abstract${className}Visitable>>() {

	override fun getItemCount(): Int {
		return ${className?uncap_first}Visitables.size
	}

	override fun getItemViewType(position: Int): Int {
		return ${className?uncap_first}Visitables[position].type(${className?uncap_first}TypeFactory)
	}
	<#if areListItemsClickable>

	private val itemClickSubject = PublishSubject.create<BaseViewHolder<Abstract${className}Visitable>>()

	fun getViewClickedObservable(): Observable<BaseViewHolder<Abstract${className}Visitable>> {
		return itemClickSubject
	}
	</#if>

	interface ${className}TypeFactory {
		fun type(${className?uncap_first}Item: ${className}Item): Int
		fun holder(type: Int, view: View): BaseViewHolder<*>
	}

	override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BaseViewHolder<Abstract${className}Visitable> {
		val view = LayoutInflater.from(parent.context).inflate(viewType, parent, false)
		<#if areListItemsClickable>val v = <#else>return </#if>${className?uncap_first}TypeFactory.holder(viewType, view) as BaseViewHolder<Abstract${className}Visitable>
		<#if areListItemsClickable>
		RxView.clicks(view)
				.takeUntil(RxView.detaches(parent))
				.map { v }
				.subscribe(itemClickSubject)
		return v
		</#if>
	}

	override fun onBindViewHolder(holder: BaseViewHolder<Abstract${className}Visitable>, position: Int) {
		holder.bind(${className?uncap_first}Visitables[position])
	}

	fun updateItems(visitables: List<Abstract${className}Visitable>) {
		${className?uncap_first}Visitables = visitables
		notifyDataSetChanged()
	}
}