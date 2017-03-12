function main() {
  setInterval(function() {
    $.get("/status", function(data) {
      switch (data.label) {
        case "-":
          $("#box").html("no data");
          break;
        case "1":
          $("#box").html("<img src='class1.jpg'>");
          break;
        case "0":
          $("#box").html("<img src='class0.jpg'>");
          break;
      }
    }).fail(function() {
      $("#box").html("error");
    });
  }, 100);
}

main();
