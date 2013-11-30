/*
 * ESMS Javascript code-behind
 *
 * These JavaScript functions styles are used by the ESMS Application
 */

function refreshParent()
{
	window.opener.location.href = window.opener.location.href; 
	if (window.opener.progressWindow)
	{
		window.opener.progressWindow.close();
	}  
	window.close();
}

function printWin() 
{
	window.print();
} 