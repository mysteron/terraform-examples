exports.handler = async (event, context) => {
  console.log("Received event:", JSON.stringify(event));
  const response = {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello from Lambda!" }),
  };
  return response;
};
