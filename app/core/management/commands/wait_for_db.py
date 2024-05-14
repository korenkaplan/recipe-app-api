"""
 Django command to wait for the database to be available on creation
"""
import time
from django.core.management.base import BaseCommand
from psycopg2 import OperationalError as Psycopg2OpError
from django.db.utils import OperationalError


class Command(BaseCommand):
    """Django class to wait for the database"""

    def handle(self, *args, **options):
        """Entrypoint for command"""
        # stdout = log to terminal
        self.stdout.write("Waiting for database...")
        is_db_up = False
        while is_db_up is False:
            try:
                self.check(databases=['default'])
                is_db_up = True
            except (Psycopg2OpError, OperationalError):
                self.stdout.write(self.style.ERROR('Database not available waiting 1 second...'))
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS('Database available!'))
           
