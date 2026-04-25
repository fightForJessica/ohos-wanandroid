import hilog from "@ohos.hilog"

export default class Logger{

  private static readonly DOMAIN: number = 0x0001
  private static readonly TAG: string = "MyWatching"
  private static ENABLE = true

  static i(msg: string) {
    if (Logger.ENABLE) {
      hilog.info(Logger.DOMAIN, Logger.TAG, msg)
    }
  }

  static e(msg: string) {
    if (Logger.ENABLE) {
      hilog.error(Logger.DOMAIN, Logger.TAG, msg)
    }
  }

}