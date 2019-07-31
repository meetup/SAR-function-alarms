const log = require("lambda-log");

exports.handler = async (event, context) => {
  if (event.error) {
    throw new Error("I errored!");
  }
  return {success: true}
}

exports.byeHandler = async (event, context) => {
  if (event.isJavaScript) {
    log.error("I logged an error instead");
    return {success: false}
  } else {
    throw new Error("bye");
  }
}