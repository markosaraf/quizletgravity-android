(function () {
  if (location.protocol !== 'https:' || !['quizletgravity.com', 'www.quizletgravity.com'].includes(location.hostname)) return;
  if (document.getElementById('gravity-native-support')) return;
  const footer = document.createElement('footer');
  footer.id = 'gravity-native-support';
  footer.style.cssText = 'padding:20px;text-align:center;background:#0b1033;color:white;font:14px/1.5 system-ui,sans-serif';
  const privacy = document.createElement('a');
  privacy.href = 'https://markosaraf.github.io/quizletgravity-android/privacy.html';
  privacy.textContent = 'Privacy policy';
  privacy.style.cssText = 'color:white;text-decoration:underline';
  const support = document.createElement('a');
  support.href = 'https://markosaraf.github.io/quizletgravity-android/';
  support.textContent = 'Support';
  support.style.cssText = privacy.style.cssText;
  footer.append(privacy, document.createTextNode(' · '), support);
  document.body.appendChild(footer);
})();
