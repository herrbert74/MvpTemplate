package ${fullPackageName}.list

import android.view.View
import ${applicationPackage}.R
import ${basePackageName}.mvp.list.BaseViewHolder

class ${className}TypeFactory : ${className}Adapter.${className}TypeFactory {
	override fun type(${className?uncap_first}Item: ${className}Item): Int =  R.layout.row_${camelCaseToUnderscore(className)}

	override fun holder(type: Int, view: View): BaseViewHolder<*> {
		return when(type) {
			R.layout.row_${className?uncap_first} -> ${className}ViewHolder(view)
			else -> throw RuntimeException("Illegal view type")
		}
	}
}