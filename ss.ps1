$SDToken = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('sky-kshatriyan:695ab53fe8cc377efad224b7e32ada72435334db'))
$SDIRMParams 	=	@{
	Uri	           =   "https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/e7dd89aa60eba02619a760ae3f0a8265ca122343"
	Method         =   'POST'
	ContentType    =   'application/json'
	Headers        =   @{Authorization=("Basic {0}" -f $SDToken)}
	Body           =   (@{ state = "success"; context = "build"; description = "Build succeeded"; target_url = $null} | ConvertTo-Json)
}
IWR @SDIRMParams