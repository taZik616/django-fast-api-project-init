# from settings.settings import SMS_RU_API_KEY

from django.db import models


class ServerSetting(models.Model):
    # sms_ru_api_key = models.CharField(default=SMS_RU_API_KEY, max_length=125)
    isUsed = models.BooleanField(
        default=True, verbose_name='Используется клиент-приложениями')

    def __str__(self):
        return f"{self.pk} - Используются клиент-приложениями: [{'ДА' if self.isUsed else 'НЕТ'}]"

    class Meta:
        verbose_name = 'Настройки сервера'
        verbose_name_plural = 'Настройка сервера'