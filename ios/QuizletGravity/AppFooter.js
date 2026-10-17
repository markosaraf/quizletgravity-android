(function () {
  if (location.protocol !== 'https:' || !['quizletgravity.com', 'www.quizletgravity.com'].includes(location.hostname)) return;
  if (!document.getElementById('gravity-native-layout')) {
    const style = document.createElement('style');
    style.id = 'gravity-native-layout';
    // The site's phone controls, selected by input device instead of iPad width.
    // Keep the real viewport width: don't magnify text or falsify game coordinates.
    style.textContent = `
      html[data-gravity-input="touch"] .GravityModeLayout-sidebar { display: none; }
      html[data-gravity-input="touch"] .GravityMobileControlsBar { display: none; }
      html[data-gravity-input="touch"] .GravitySiteHeader-mobileControls { display: flex; }
      html[data-gravity-input="touch"] .GravitySiteHeader-setTitle { display: none; }
      html[data-gravity-input="touch"] .GravitySiteHeader { height: auto; min-height: 3.5rem; padding: .5rem 1rem; }
      html[data-gravity-input="touch"] .GravityModeLayout { min-height: auto; }
      html[data-gravity-input="touch"] .GravityModeLayout-main { min-height: calc(100vh - 3.5rem); }
      html[data-gravity-input="touch"] .GravityGameplayView-typingPrompt { width: 100%; }
      html[data-gravity-input="touch"] .GravityUIRow { flex-direction: column; gap: 1.5rem; }
      html[data-gravity-input="keyboard"] .GravityModeLayout-sidebar { display: flex; }
      html[data-gravity-input="keyboard"] .GravitySiteHeader-mobileControls { display: none; }
      html[data-gravity-input="keyboard"] .GravitySiteHeader-setTitle { display: block; }
      html[data-gravity-input="keyboard"] .GravitySiteHeader { height: 3rem; min-height: 0; padding: 0 1rem; }
      html[data-gravity-input="keyboard"] .GravityModeLayout,
      html[data-gravity-input="keyboard"] .GravityModeLayout-main { min-height: calc(100vh - 3rem); }
      html[data-gravity-input="keyboard"] .GravityUIRow { flex-direction: row; gap: 2rem; }
    `;
    document.head.appendChild(style);
  }
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
