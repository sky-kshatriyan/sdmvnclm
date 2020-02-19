$SDToken = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("sky-kshatriyan:$gitHubApiToken"))
$SDIRMParams 	=	@{
	Uri	 =	"https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/${commitId}"
	Method = 'POST'
	ContentType = 'application/json'
	Headers = @{Authorization=('Basic {0}' -f $SDToken)}
	Body = (@{ state = "success"; context = "build"; description = "done"; target_url = $null} | ConvertTo-Json)
}
IWR @SDIRMParams