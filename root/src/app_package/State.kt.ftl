package ${fullPackageName}

import ${basePackageName}.mvp.BaseState
import ${fullPackageName}.list.Abstract${className}Visitable

enum class ContentChange {
	NONE,
	${listClassNamePlural?upper_case}_RECEIVED
}

data class ${className}State(
		var ${listClassName?uncap_first}Items: List<Abstract${className}Visitable> = ArrayList()
) : BaseState() {
	/*var page: Int? = null
	var perPage: Int? = null
	var total: Int? = null*/
	var ${parameterName}: ${parameterType}? = ""
	var contentChange: ContentChange = ContentChange.NONE
}