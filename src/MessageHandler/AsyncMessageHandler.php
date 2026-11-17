<?php

declare(strict_types=1);

namespace App\MessageHandler;

use App\Message\AsyncMessage;
use Symfony\Component\Messenger\Attribute\AsMessageHandler;

#[AsMessageHandler]
final class AsyncMessageHandler
{
    public function __invoke(AsyncMessage $message): void
    {
        // Handle asynchronous work here.
    }
}
