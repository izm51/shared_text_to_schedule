/* eslint-disable @typescript-eslint/no-explicit-any */
import * as firebaseFunctionsTest from "firebase-functions-test";
import {helloWorld} from "../src/index";

firebaseFunctionsTest();

describe("helloWorld", () => {
  test("Call the function helloWorld must return message", () => {
    const req = {} as any;

    const res = {
      send: (payload: any) => {
        expect(payload).toBe("Hello from Firebase!");
      },
    } as any;

    helloWorld(req, res);
  });
});
