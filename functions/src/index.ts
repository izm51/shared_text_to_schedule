import * as functions from "firebase-functions";
import * as logger from "firebase-functions/logger";

import { extractSchedule as extractScheduleFunc } from "./features/openai/service";
import { CalndarSchedule } from "./features/openai/domain";

export const healthCheck = functions.https.onCall(
  (_, context: functions.https.CallableContext) => {
    logger.info(`[called]: ${context?.rawRequest?.originalUrl}`);
    return { message: "I'm OK!" };
  }
);
export const extractSchedule = functions.https.onCall(
  async (data, context: functions.https.CallableContext) => {
    logger.info(`[called]: ${context?.rawRequest?.originalUrl}`);
    // TODO: 認証追加
    const schedule: CalndarSchedule = await extractScheduleFunc(data.text);
    return schedule;
  }
);
