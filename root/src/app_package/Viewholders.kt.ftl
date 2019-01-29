package ${fullPackageName}.list

import android.view.View
import kotlinx.android.synthetic.main.row_${className?uncap_first}.view.*
import ${basePackageName}.mvp.list.BaseViewHolder

class ${className}ViewHolder(itemView: View) : BaseViewHolder<Abstract${className}Visitable>(itemView) {
	override fun bind(visitable: Abstract${className}Visitable) {
		val ${className?uncap_first}Item = (item as ${className}Visitable).${className?uncap_first}Item
		//itemView.doSomethingWithMe()
	}
}