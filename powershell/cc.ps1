$newArgs = @($args | ForEach-Object { $_ -replace 'pc-windows-msvc', 'windows-gnu' })
& zig cc @newArgs
exit $LASTEXITCODE
