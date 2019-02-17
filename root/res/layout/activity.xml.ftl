<?xml version="1.0" encoding="utf-8"?>
<android.support.design.widget.CoordinatorLayout xmlns:android="http://schemas.android.com/apk/res/android"
												 xmlns:app="http://schemas.android.com/apk/res-auto"
												 xmlns:tools="http://schemas.android.com/tools"
												 android:layout_width="match_parent"
												 android:layout_height="match_parent"
												 android:fitsSystemWindows="true"
												 tools:context="${fullPackageName}.${className}Activity">

	<com.babestudios.base.view.ParallaxAppBarView
		android:id="@+id/pab${className}"
		android:layout_width="match_parent"
		android:layout_height="@dimen/appbar_height"
		android:theme="@style/AppTheme.AppBarOverlay"
		app:imageViewSrc="@drawable/bg_${className?lower_case}"/>
<#if showFab>
	<android.support.design.widget.FloatingActionButton
		android:id="@+id/fab${className}"
		android:layout_width="wrap_content"
		android:layout_height="wrap_content"
		android:layout_gravity="bottom|end"
		android:layout_margin="@dimen/fab_margin"
		app:srcCompat="@drawable/ic_"/>
</#if>

	<com.babestudios.base.view.MultiStateView
		android:id="@+id/msv${className}"
		android:layout_width="match_parent"
		android:layout_height="match_parent"
		app:layout_behavior="android.support.design.widget.AppBarLayout$ScrollingViewBehavior"
		app:msv_emptyView="@layout/multi_state_view_empty"
		app:msv_errorView="@layout/multi_state_view_error"
		app:msv_loadingView="@layout/multi_state_view_progress"
		app:msv_viewState="content">

	<#if isList>
		<android.support.v7.widget.RecyclerView
			android:id="@+id/rv${className}"
			android:layout_width="match_parent"
			android:layout_height="match_parent"
			android:paddingBottom="@dimen/view_margin_small"
			android:scrollbars="vertical"/>
	</#if>
	</com.babestudios.base.view.MultiStateView>
	
</android.support.design.widget.CoordinatorLayout>
