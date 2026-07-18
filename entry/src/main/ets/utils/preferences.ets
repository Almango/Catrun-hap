import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

// 唯一的Key
const REFRESH_TOKEN = 'RefreshToken';
const USER_ACCOUNT = 'userAccount';

let dataPreferences: preferences.Preferences | null = null;
let isInitialized = false;

// 初始化函数 - 在 EntryAbility 中调用
export function initPreferences(context: common.UIAbilityContext) {
  try {
    dataPreferences = preferences.getPreferencesSync(context, { name: 'Container' });
    isInitialized = true;
    console.info('已完成初始化');
  } catch (err) {
    console.error('初始化操作失败:', err);
    isInitialized = false;
  }
}

// 确保 preferences 已初始化
function ensurePreferences(): boolean {
  if (!isInitialized || !dataPreferences) {
    console.warn('Preferences not initialized');
    return false;
  }
  return true;
}

// 保存 token
export async function saveToken(account:string, token: string): Promise<boolean> {
  try {
    await dataPreferences!.put(USER_ACCOUNT, account);
    await dataPreferences!.put(REFRESH_TOKEN, token);
    await dataPreferences!.flush();
    console.info('Token保存成功');
    return true;
  } catch (err) {
    console.error('Token保存失败:', err);
    return false;
  }
}


export function showToken(): [string, string] {
  if (!ensurePreferences()) {
    console.warn('无法获取令牌：设置未就绪');
    return ['', ''];
  }
  try {
    const account = dataPreferences!.getSync(USER_ACCOUNT, '').toString();
    const token = dataPreferences!.getSync(REFRESH_TOKEN, '').toString();
    return [account, token];
  } catch (err) {
    console.error('读取Token失败:', err);
    return ['', ''];
  }
}

export function checkToken(): boolean {
  if (!ensurePreferences()) {
    console.warn('无法获取令牌：设置未就绪');
    console.info('密钥已失效，请重新登录');
    return false;
  }
  try {
    const token = dataPreferences!.getSync(REFRESH_TOKEN, '');
    const hasToken = !!token?.toString();
    if (hasToken) {
      console.info('密钥检测为有效');
      return true;
    } else {
      console.info('密钥已失效，请重新登录');
      return false;
    }
  } catch (err) {
    console.info('密钥已失效，请重新登录');
    return false;
  }
}

// 登出清除token并跳转指定页面
export async function clearToken(ctx: UIContext, url: string): Promise<void> {
  try {
    await dataPreferences!.delete(USER_ACCOUNT);
    await dataPreferences!.delete(REFRESH_TOKEN);
    await dataPreferences!.flush();
    console.info('登出成功，跳转页面');
  } catch (err){
    console.error('登出清除token失败:', err);
  }
  // 无论清除成功失败，一律跳转目标页面
  ctx.getRouter().replaceUrl({ url: url });
}


// export function getUserdata(): UserData {
//   try {
//     const token = dataPreferences!.getSync(TOKEN_KEY, '') as string;
//     const username = dataPreferences!.getSync(USERNAME, '') as string ;
//     const sex = dataPreferences!.getSync(SEX, '未知') as string;
//     const birthday = dataPreferences!.getSync(BIRTHDAY, '') as string;
//     const desc = dataPreferences!.getSync(DESCRIPTION, '') as string;
//
//     const result:UserData = {token, username, sex, birthday, desc}
//
//     return { token, username, sex, birthday, desc };
//   } catch (err) {
//     console.error('读取用户信息失败', err);
//     return err;
//   }
// }