import {Prompt} from "ets/common/prompt";
import { checkToken, saveToken, showToken } from "ets/utils/preferences";
import { GetVerifyCode, LoginByCode } from "ets/utils/auth";

@Entry()
@ComponentV2
struct Login {
  @Local account: string = ''
  @Local codeText: string = '获取验证码'
  @Local code:string = '';
  @Local countDown: number = 0


  aboutToAppear(): void {
    if (checkToken()) {
      this.getUIContext().getRouter().replaceUrl({
        url: "pages/Index"
      })
    }
  }

  build() {
    Column({space:24}){

      Column({space:12}){
        Text('手机登录').fontSize('20')
        Text('新账号将自动注册，仅限中国大陆手机号').fontSize('16').fontColor('#ff6b6b6b')
      }.width('100%').alignItems(HorizontalAlign.Start).padding({left:34, right:34, top:50})

      Column(){
        Row({space:12}){
          Text('+86').fontSize(18)
          Line().width(1).height(20).backgroundColor('#ffcccccc')
          TextInput({placeholder:'请输入账号'}).fontSize(18).height(60).placeholderFont({size:18}).backgroundColor(Color.Transparent).layoutWeight(1)
            .placeholderColor('#ffbbbbbb').padding(0).onChange((value)=>{
            this.account = value
          })
        }
        Line().width('100%').height(1).backgroundColor('#ffeeeeee')
        Row({space:12}){
          TextInput({placeholder:'请输入验证码'}).type(InputType.Number).fontSize(18).height(60).placeholderFont({size:18}).backgroundColor(Color.Transparent).layoutWeight(1)
            .placeholderColor('#ffbbbbbb').padding(0).onChange((value)=>{
              this.code = value
          })
          Line().width(1).height(20).backgroundColor('#ffcccccc')
          Text(this.codeText)
            .fontSize(18)
            .fontColor(this.countDown > 0 ? '#ffbbbbbb' : '#ff303030')
            .onClick(async ()=>{
              // 倒计时中直接返回，禁止点击
              if (this.countDown > 0) return

              if (this.account.length !== 11){
                Prompt(this.getUIContext(), '请输入有效的手机号')
                return
              }
              // 请求接口获取验证码
              const res = await GetVerifyCode(this.account)
              if (res.code === 200) {
                // 开始60秒倒计时
                this.countDown = 60
                const timer = setInterval(() => {
                  this.countDown--
                  this.codeText = `${this.countDown}s后重发`
                  if (this.countDown <= 0) {
                    clearInterval(timer)
                    this.codeText = '获取验证码'
                  }
                }, 1000)
              } else {
                Prompt(this.getUIContext(), res.message)
              }
            })
        }
        Line().width('100%').height(1).backgroundColor('#ffeeeeee')
      }.margin({top:50}).padding(34)
      Column(){
        Button('立即登录')
          .width('150')
          .height(46)
          .fontSize(16)
          .borderRadius('12')
          .backgroundColor('#ff17a56e')
          .enabled(this.account.length === 11)
          .onClick(async ()=>{
            if (this.code.length === 0){
              Prompt(this.getUIContext(), "验证码不能为空")
            }

            else {
             const message =  await LoginByCode(this.account, this.code)
              // ** 保存AccessToken令牌至内存 ** //
             AppStorage.setOrCreate('accessToken', message.data.accessToken)
              console.log('短期Key：',AppStorage.get('accessToken'))
              // ** 保存RefreshTkone令牌至本地持久化 ** //
             saveToken(this.account, message.data.refreshToken)
             Prompt(this.getUIContext(), message.message)
              this.getUIContext().getRouter().replaceUrl({
                url: "pages/Index"
              })
            }
          })
      }.margin({top:50}).padding(34)

    }.height('100%').width('100%')
  }
}
