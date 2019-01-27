package ${fullPackageName}.list

abstract class Abstract${className}Visitable {
	abstract fun type(${className?uncap_first}TypeFactory: ${className}Adapter.${className}TypeFactory): Int
}

class ${className}Visitable(val ${className?uncap_first}Item: ${className}Item) : Abstract${className}Visitable() {
	override fun type(${className?uncap_first}TypeFactory: ${className}Adapter.${className}TypeFactory): Int {
		return ${className?uncap_first}TypeFactory.type(${className?uncap_first}Item)
	}
}