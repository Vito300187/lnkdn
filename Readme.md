1) Перед тем, как запустить обходчик, нужно вручную, через обычный браузер войти в профиль. Система защиты, раз в сутки, пытается проверить, что Вы не бот, с помощью капчи.
2) В профиле пользователя, должен быть указан номер телефона, это полезно как для безопасности, так и для восстановления доступа.
   Текущая реализация обходчика, не подразумевает попадание на страницу, где Линкедин предлагает указать телефон.
3) Линкедин заблокирован во многих странах, соответственно нужен стабильный(и бесплатный) VPN - `https://www.freeopenvpn.org`, либо скрипт можно запускать с сервера, который расположен не в России - `https://www.serverhunter.com`
4) В Скрипте присутстует возможность, подключения `Selenoid`. Для подключения требуется установка `https://aerokube.com/selenoid/latest/`. Capybara уже настроена. Остается только запустить скрипт с доп. ключом `SELEN=true`.
6) Команда для запуска обходчика:
   - `SELEN=true` - Опциональна, для запуска Selenoid и просмотра результата выполнения скрипта с помошью `VNC`.
   - `RECORD_VIDEO` - Запись видео, пройденного теста. Доступно только после окончания теста и если запущен параметр `SELEN`. Видео доступно по ссылке `http://localhost:4444/video/`
   - `MY_LOGIN` - логин
   - `MY_PASSWORD` - пароль
   - `MY_LOCATION` - местоположение, где производить поиск HR. Параметр может принимать так же (по умолчанию Russia) и город (например Krasnodar)
   - `MY_JOB` - название вакансии для поиска, по которой можно найти HR (по умолчанию ruby hr)
   - `ADD_NOTE=true` - при установке контакта, можно заполнить раздел Add note, для представления себя или описание что нужно от того, кому предлагаете connect. 
   Текст сопроводительного письма, можно заполнить в файле `./note_for_hr.txt`
   - `rspec main_linkedin.rb` - команда для запуска скрипта
Итого, команда выглядит как `MY_LOGIN=логин MY_PASSWORD=пароль MY_LOCATION=страна/город MY_JOB=вакансия ADD_NOTE=true rspec main_linkedin.rb`
7) Скрипт имеет произвольные скроллы на странице, дабы добавить "поведение обычного пользователя"
8) В папке `/usr/local/bin` должен присутствовать `chromedriver`, версии равной версии браузера.
Актуальную версию для скачивания(Latest stable release), можно найти по ссылке `https://chromedriver.chromium.org`

Есть 2 версии образов докер, с предустановленным набором lib и драйверов, для удобства использовния.
Docker образ, с полной версией хрома и полноценной Ubuntu:
- ruby 2.7.0
- последние стабильные версии chrome и chromedriver (не захаркоженные)
`docker pull kuzminow/linkedin_chrome`

Облегченный Docker образ:
- с установленным alpine-ruby-2.7.0
- с загрузкой и установкой свежей версии, chromium и chromium-chromedriver (не захаркоженные)
`docker pull kuzminow/linkedin_chromium` 
