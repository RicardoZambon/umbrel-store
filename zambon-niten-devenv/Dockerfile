FROM codercom/code-server:latest

USER root

# Install dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        curl \
        wget \
        git \
        openssh-client \
        openssh-server \
        sshpass \
        ca-certificates \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Install .NET SDK 9.0
RUN wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh --channel 9.0 --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/local/bin/dotnet \
    && rm /tmp/dotnet-install.sh

ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="${PATH}:/usr/share/dotnet"

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Configure SSH server
RUN mkdir -p /run/sshd \
    && echo 'coder:coder' | chpasswd \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Install VS Code extensions from Open VSX
# Note: ms-dotnettools.csharp and csdevkit are Microsoft-proprietary
# and not available on Open VSX. Use "C# Dev Kit" alternative or
# connect with VS Code Remote SSH for full C# support.
RUN code-server \
    --install-extension angular.ng-template \
    --install-extension dbaeumer.vscode-eslint \
    --install-extension esbenp.prettier-vscode \
    --install-extension bradlc.vscode-tailwindcss \
    --install-extension muhammad-sammy.csharp \
    ; exit 0

# Create custom entrypoint that starts SSH + code-server
RUN printf '#!/bin/bash\n/usr/sbin/sshd\nexec /usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8443 --auth password /home/coder/workspace\n' \
    > /usr/bin/entrypoint-custom.sh \
    && chmod +x /usr/bin/entrypoint-custom.sh

USER 1000

ENTRYPOINT ["/usr/bin/entrypoint-custom.sh"]
