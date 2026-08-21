# Reads text on stdin and sends it through the SSH reverse tunnel to the Mac's
# pbcopy listener (127.0.0.1:52371 on this box -> RemoteForward -> Mac). Used by
# Neovim's TextYankPost hook so yanks land in the Mac clipboard. Fails silently if
# no SSH session with the RemoteForward is active.
$ErrorActionPreference = 'Stop'
$text = [Console]::In.ReadToEnd()
try {
    $client = New-Object System.Net.Sockets.TcpClient('127.0.0.1', 52371)
    $stream = $client.GetStream()
    $bytes = [Text.Encoding]::UTF8.GetBytes($text)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Flush()
    $stream.Close()
    $client.Close()
} catch {
    # bridge not connected; nothing to do
}
