document.getElementById("click-me").addEventListener("click", () => {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      let url = tabs[0].url;
      console.log("The URL of the current tab is:", url);
    });
  });