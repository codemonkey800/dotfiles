import http.server as http
import os.path as path
from socket import gethostname
from socketserver import TCPServer
from subprocess import run
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

PORT = 8080


class ResumeBuilderEventHandler(FileSystemEventHandler):
    '''Event handler class that runs make whenever resume.tex is updated.'''
    def on_modified(self, event):
        if event.is_directory or event.src_path != './resume.tex':
            return
        run(['clear'])
        run(['make'])


def main():
    if not path.exists('build'):
        run(['make'])

    observer = Observer()
    observer.schedule(ResumeBuilderEventHandler(), '.')
    observer.start()

    try:
        with TCPServer(("", PORT), http.SimpleHTTPRequestHandler) as server:
            print('Started make server!')
            print((
                'See resume build at '
                f'http://{gethostname()}:{PORT}/build/resume.pdf'
            ))
            server.serve_forever()
    except KeyboardInterrupt:
        print('Stopping watcher.')
        observer.stop()

    observer.join()
    print('Server stopped!')


if __name__ == "__main__":
    main()
