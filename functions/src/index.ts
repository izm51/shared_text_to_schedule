import * as functions from "firebase-functions";
import * as logger from "firebase-functions/logger";

import { extractSchedule as extractScheduleFunc } from "./features/openai/service";
import { CalndarSchedule } from "./features/openai/domain";

const useAuthentication = (process.env.USE_AUTHENTICATION || "true") === "true";

export const healthCheck = functions.https.onCall((_) => {
  logger.info("[healthCheck]: called");
  return { message: "I'm OK!" };
});
export const extractSchedule = functions.https.onCall(
  async (data: any, context: functions.https.CallableContext) => {
    logger.info("[extractSchedule]: called");

    if (useAuthentication && !context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "unauthenticated"
      );
    }

    logger.info("[extractSchedule]: data:", data);
    if (!data.text) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "invalid request parameters"
      );
    }

    const schedule: CalndarSchedule = await extractScheduleFunc(data.text);
    return schedule;
  }
);
