exports.handler = async (event) => {
  console.log("Hello, module 3.6 package vulnerability!");

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello, module 3.6 package vulnerability!",
    }),
  };
};
