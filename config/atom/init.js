'use babel';

import fs from 'fs';
import { resolve } from 'path';

function deletePath(path) {
  if (!fs.existsSync(path)) return;
  else if (!fs.statSync(path).isDirectory()) fs.unlinkSync(path);
  else {
    fs.readdirSync(path).forEach(file => deletePath(resolve(path, file)));
    fs.rmdirSync(path);
  }
}

atom.commands.add('atom-workspace', 'user:dismiss-notifications', () => {
  atom.notifications.getNotifications().forEach(
      notification => notification.dismiss(),
  );
  atom.notifications.clear();
});

atom.commands.add('atom-workspace', 'user:tree-view-delete', () => {
  const { treeView }= atom.packages.getActivePackage('tree-view').mainModule;
  deletePath(treeView.selectedPath);
});
