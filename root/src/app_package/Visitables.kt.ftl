package ${fullPackageName}.list

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

abstract class Abstract${className}Visitable : Parcelable{
	abstract fun type(${className?uncap_first}TypeFactory: ${className}Adapter.${className}TypeFactory): Int
}

@Parcelize
class ${className}Visitable(val ${className?uncap_first}Item: ${className}Item) : Abstract${className}Visitable(), Parcelable {
	override fun type(${className?uncap_first}TypeFactory: ${className}Adapter.${className}TypeFactory): Int {
		return ${className?uncap_first}TypeFactory.type(${className?uncap_first}Item)
	}
}