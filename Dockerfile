FROM python:3.9.7-slim@sha256:8ce5557f22de9bfbc38bac7f084e6384245c837d9795015448b943f9e5dfec89 as dependencies

RUN pip install pipenv

WORKDIR app

COPY jmc jmc
COPY resources resources
COPY Pipfile Pipfile.lock ./

FROM dependencies as test
RUN pipenv install --dev --system
COPY test test
ENTRYPOINT []
CMD ["python3", "-m", "pytest", "--cov=jmc.github_actions.__main__", "--cov-report", "html", "--cov-report", "xml", "-s"]

FROM dependencies as lambda
RUN pipenv install --system
CMD ["python3", "jmc/github_actions/__main__.py"]