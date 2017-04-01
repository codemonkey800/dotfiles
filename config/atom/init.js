'use babel';

atom.commands.add('atom-workspace', 'user:dismiss-notifications', () => {
  atom.notifications.getNotifications().forEach(
      notification => notification.dismiss(),
  );
  atom.notifications.clear();
});
