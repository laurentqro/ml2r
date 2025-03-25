document.addEventListener('DOMContentLoaded', () => {
  const flashMessages = document.querySelectorAll('[role="alert"]');

  flashMessages.forEach(message => {
    setTimeout(() => {
      message.style.transition = 'opacity 0.3s ease-out';
      message.style.opacity = '0';
      setTimeout(() => message.remove(), 300);
    }, 2000);
  });
});