package ${fullPackageName}.list

import android.support.v7.util.DiffUtil
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.jakewharton.rxbinding2.view.RxView
import io.reactivex.Observable
import io.reactivex.subjects.PublishSubject
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

	private val itemClickSubject = PublishSubject.create<BaseViewHolder<Abstract${className}Visitable>>()

	fun getViewClickedObservable(): Observable<BaseViewHolder<Abstract${className}Visitable>> {
		return itemClickSubject
	}

	interface ${className}TypeFactory {
		fun type(${className?uncap_first}Item: ${className}Item): Int
		fun holder(type: Int, view: View): BaseViewHolder<*>
	}

	override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BaseViewHolder<Abstract${className}Visitable> {
		val view = LayoutInflater.from(parent.context).inflate(viewType, parent, false)
		val v =  ${className?uncap_first}TypeFactory.holder(viewType, view) as BaseViewHolder<Abstract${className}Visitable>
		RxView.clicks(view)
				.takeUntil(RxView.detaches(parent))
				.map { v }
				.subscribe(itemClickSubject)
		return v
	}

	override fun onBindViewHolder(holder: BaseViewHolder<Abstract${className}Visitable>, position: Int) {
		holder.bind(${className?uncap_first}Visitables[position])
	}

	/*fun updateItems(newChannelVisitables: List<ChannelVisitable>) {
		val diffResult = DiffUtil.calculateDiff(ChatListDiffUtilCallback(channelVisitables, newChannelVisitables))
		channelVisitables = ArrayList(newChannelVisitables)
		diffResult.dispatchUpdatesTo(this)
	}*/
}