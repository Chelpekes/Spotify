# 1. Запускаем notepad и получаем объект процесса
$proc = Start-Process notepad -PassThru

# 2. Подключаем функцию установки заголовка окна
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern bool SetWindowText(IntPtr hWnd, string lpString);
}
"@

# 3. Ждём, пока у процесса появится главное окно (макс. 5 секунд)
$timeout = [DateTime]::Now.AddSeconds(5)
while (-not $proc.MainWindowHandle) {
    if ([DateTime]::Now -gt $timeout) { break }
    Start-Sleep -Milliseconds 100
}

# 4. Ставим свой заголовок
[WinAPI]::SetWindowText($proc.MainWindowHandle, "Твой батя “Безымянный”")

# 5. (Опционально) Ждём закрытия, чтобы скрипт не завершился раньше
$proc.WaitForExit()
