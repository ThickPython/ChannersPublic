# Article

How handlers work

## Overview

How handlers work in conjunction with navigation path

NavigationPath manager receives data on click from active view

-> Depending on the data, it may add a thread/catalog/etc to the stack

-> Calls the active handlers for those types and loads one as the active

-> -> Navigation destination loada catalog/thread view

-> -> catalog/thread view loads data from respective handlers the active thread/catalog
