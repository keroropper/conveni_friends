document.addEventListener("turbolinks:load", () => {
  const title = document.querySelector('#recruit_title');
  const explain = document.querySelector('#recruit_explain');
  title.addEventListener('input', (event) => countClc(event, 'title'));
  explain.addEventListener('input', (event) => countClc(event, 'explain'));
  
  function countClc(event, fieldName) {
    const wordCount = document.querySelector(`.${fieldName}-word-count`);
    targetVal = event.target.value.length.toString();
    wordCount.textContent = targetVal;
  }
});