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
	var totalCount: Int? = null
	var ${parameterName}: ${parameterType}? = ""
	var contentChange: ContentChange = ContentChange.NONE
}