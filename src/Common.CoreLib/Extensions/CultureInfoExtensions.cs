using System.Globalization;

// ReSharper disable once CheckNamespace
namespace System
{
    public static class CultureInfoExtensions
    {
        public static bool IsMatch(CultureInfo cultureInfo, string cultureName)
        {
            if (string.IsNullOrWhiteSpace(cultureInfo.Name))
            {
                return false;
            }
            if (cultureInfo.Name == cultureName)
            {
                return true;
            }
            else
            {
                return IsMatch(cultureInfo.Parent, cultureName);
            }
        }

        public static string GetAcceptLanguage(this CultureInfo culture)
        {
            if (IsMatch(culture, "zh-Hans"))
            {
                return "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7";
            }
            else if (IsMatch(culture, "zh-Hant"))
            {
                return "zh-HK,zh-TW,zh;q=0.9,en-US;q=0.8,en;q=0.7";
            }
            else if (IsMatch(culture, "ko"))
            {
                return "ko;q=0.9,en-US;q=0.8,en;q=0.7";
            }
            else if (IsMatch(culture, "ja"))
            {
                return "ja;q=0.9,en-US;q=0.8,en;q=0.7";
            }
            else if (IsMatch(culture, "ru"))
            {
                return "ru;q=0.9,en-US;q=0.8,en;q=0.7";
            }
            else
            {
                return "en-US;q=0.9,en;q=0.8";
            }
        }

        // https://docs.microsoft.com/zh-cn/openspecs/windows_protocols/ms-lcid/a9eac961-e77d-41a6-90a5-ce1a8b0cdb9c

        public const int LCID_zh_CN = 0x0804;
        public const int LCID_en_US = 0x0409;
    }
}