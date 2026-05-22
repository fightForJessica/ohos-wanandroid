import axios from "@ohos/axios";

const BASE_URL = "https://wanandroid.com"

export default class BaseResposity {

  private instance = axios.create({
    baseURL: BASE_URL,
    timeout: 5000
  })

  protected async get<T>(url: string, params?: object): Promise<T> {
    return (await this.instance.get(url, { params: params })).data
  }

  protected async post<T>(url: string, params?: object): Promise<T> {
    return (await this.instance.post(url, params)).data
  }

}