import OpenAI from "openai";
import "dotenv/config";

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const systemMessage = `\
ユーザーから与えられた文章から、日程情報を抽出してください。
出力は次のようなJSON形式としてください。

{
  title: string, // 予定のタイトル
  start_date: YYYYMMDD, // 開始日
  start_time: hhmmss, // 開始時刻
  end_date: YYYYMMDD, // 終了日
  end_time: hhmmss, // 終了時刻
  details: string, // 100文字以内で要約。URLは文字数に関わらず優先的に残す。改行コード"%0A"を用いて適度に改行する。
  location: string // 開催場所
}

注意:
* 出力にはJSON形式以外の内容を含まないでください。
* 主催者の名称が分かればtitleに含めてください
* locationは位置が特定しやすいようにしてください
* 終了日時が不明な場合は開始日時から2時間後にしてください。\
`;

export async function askToExtractSchedule(text: string)
  : Promise<OpenAI.Chat.Completions.ChatCompletion> {
  const chatCompletion: OpenAI.Chat.ChatCompletion =
    await openai.chat.completions.create({
      "model": "gpt-3.5-turbo-1106",
      "response_format": {"type": "json_object"},
      "messages": [
        {role: "system", content: systemMessage},
        {role: "user", content: text},
      ],
      "temperature": 0.2,
      "max_tokens": 256,
    });

  return chatCompletion;
}
